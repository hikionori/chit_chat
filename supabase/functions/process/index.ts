// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { createClient } from "npm:@supabase/supabase-js";
import { getDocument } from "npm:pdfjs-dist";
import { OpenAIEmbeddings } from "npm:@langchain/openai";

const supabaseUrl = Deno.env.get("SUPABASE_URL");
const supabaseKey = Deno.env.get("SUPABASE_ANON_KEY");

Deno.serve(async (req) => {
  if (!supabaseUrl || !supabaseKey) {
    return new Response(
      JSON.stringify({
        error: "SUPABASE_URL and SUPABASE_ANON_KEY are required",
      }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  const authorization = req.headers.get("Authorization");

  if (!authorization) {
    return new Response(
      JSON.stringify({ error: "Authorization header is required" }),
      { status: 400, headers: { "Content-Type": "application/json" } },
    );
  }

  const supabase = createClient(supabaseUrl, supabaseKey, {
    global: {
      headers: {
        authorization,
      },
    },
    auth: {
      persistSession: false,
    },
  });

  const { document_id } = await req.json();

  const { data: document } = await supabase.from("documents_with_storage_path")
    .select().eq("id", document_id).single();

  if (!document?.storage_object_path) {
    return new Response(
      JSON.stringify({ error: "Document not found" }),
      { status: 404, headers: { "Content-Type": "application/json" } },
    );
  }

  const { data: file } = await supabase.storage.from("files").download(
    document.storage_object_path,
  ); // this is a PDF file

  if (!file) {
    return new Response(
      JSON.stringify({ error: "File not found" }),
      { status: 404, headers: { "Content-Type": "application/json" } },
    );
  }

  const arrayBuffer = await file.arrayBuffer();

  const processedPdf = await processPdf(arrayBuffer);

  console.log(processedPdf[0].content.toString());

  const { error } = await supabase.from("document_sections").insert(
    processedPdf.map(({ content, embedding }) => ({
      document_id,
      content,
      embedding: embedding,
    })),
  );

  if (error) {
    return new Response(
      JSON.stringify({ error }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }

  return new Response(
    null,
    { status: 200, headers: { "Content-Type": "application/json" } },
  );
});

async function processPdf(arrayBuffer: ArrayBuffer) {
  const pdf = await getDocument(arrayBuffer).promise;

  const pages = [];
  const sections = [];

  for (let i = 1; i <= pdf.numPages; i++) {
    const page = await pdf.getPage(i);
    const textContent = await page.getTextContent();
    pages.push(textContent.items.map((item) => item.str).join(""));
  }

  const embeddingsModel = new OpenAIEmbeddings({
    openAIApiKey: Deno.env.get("OPENAI_API_KEY"),
    modelName: "text-embedding-3-large",
    dimensions: 512,
  });

  // for each page in the PDF, extract the text and send it to OpenAI for processing
  for (const page of pages) {
    const pageText = await page;
    // split the page into sections by character count
    const sectionLength = 1000;
    const sectionOverlap = 200;
    const pageSections: string[] = [];
    for (let i = 0; i < pageText.length; i += sectionLength - sectionOverlap) {
      pageSections.push(pageText.slice(i, i + sectionLength));
    }

    // send the sections to OpenAI for processing
    const sectionEmbeddings = await embeddingsModel.embedDocuments(
      pageSections,
    );

    // push map with section content and embeddings to sections array
    sections.push(
      ...sectionEmbeddings.map((embedding, index) => ({
        content: pageSections[index],
        embedding,
      })),
    );
  }

  return sections;
}
/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/process' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
