// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { createClient } from "npm:@supabase/supabase-js";
import { OpenAIEmbeddings } from "npm:@langchain/openai";

const supabaseUrl = Deno.env.get("SUPABASE_URL");
const supabaseKey = Deno.env.get("SUPABASE_ANON_KEY");

Deno.serve(async (req) => {
  if (!supabaseUrl || !supabaseKey) {
    return new Response(
      JSON.stringify({ error: "Supabase credentials not found" }),
      { status: 500 },
    );
  }

  const authorization = req.headers.get("Authorization");

  if (!authorization) {
    return new Response(
      JSON.stringify({ error: "Authorization header not found" }),
      { status: 401 },
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

  const { ids, table, contentColumn, embeddingColumn } = await req.json();

  const { data: rows, error } = await supabase.from(table).select(
    `id, ${contentColumn}`,
  ).in("id", ids).is(embeddingColumn, null);

  if (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500 },
    );
  }

  for (const row of rows) {
    const { id, [contentColumn]: content } = row;
    if (!content) {
      console.error(`Content not found for row with id: ${id}`);
      continue;
    }

    const embedder = new OpenAIEmbeddings({
      openAIApiKey: Deno.env.get("OPENAI_API_KEY"),
      modelName: "text-embedding-3-large",
      dimensions: 512,
    });

    const embedding = await embedder.embedQuery(content);
    if (!embedding) {
      console.error(`Failed to embed content for row with id: ${id}`);
      continue;
    }

    const { error } = await supabase.from(table).update({
      [embeddingColumn]: embedding,
    }).eq("id", id);

    if (error) {
      console.error(`Failed to update row with id: ${id}`);
    }

    console.log(`Generated embedding ${
      JSON.stringify({
        table,
        id,
        contentColumn,
        embeddingColumn,
      })
    }`);
  }

  return new Response(
    JSON.stringify(null),
    {
      status: 200,
      headers: { "Content-Type": "application/json" },
    },
  );
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/embed' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
