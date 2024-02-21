// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// console.log("Hello from Functions!");

import { OpenAIEmbeddings } from "npm:@langchain/openai";
import { createClient } from "npm:@supabase/supabase-js";
import { OpenAI } from "npm:openai";

const supabaseUrl = Deno.env.get("SUPABASE_URL");
const supabaseKey = Deno.env.get("SUPABASE_ANON_KEY");

Deno.serve(async (req) => {
  const { messages }: {
    messages: {
      content: string;
      role: string;
    }[];
  } = await req.json();

  const openai = new OpenAI({
    apiKey: Deno.env.get("OPENAI_API_KEY"),
  });

  const authorization = req.headers.get("Authorization");

  if (!authorization) {
    return new Response(
      JSON.stringify({ error: "Authorization header is required" }),
      { status: 400, headers: { "Content-Type": "application/json" } },
    );
  }

  const supabase = createClient(supabaseUrl!, supabaseKey!, {
    global: {
      headers: {
        authorization,
      },
    },
    auth: {
      persistSession: false,
    },
  });

  const lastMessage = messages[messages.length - 1];

  const embedder = new OpenAIEmbeddings({
    openAIApiKey: Deno.env.get("OPENAI_API_KEY"),
    modelName: "text-embedding-3-large",
    dimensions: 512,
  });
  const embedding = await embedder.embedQuery(lastMessage.content);

  // match documents with this embedding
  const { data: documents, error } = await supabase.rpc(
    "match_document_sections",
    {
      embedding: embedding,
      match_threshold: 0.5,
    },
  ).select("content")
    .limit(5);

  if (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500 },
    );
  }

  const injectedDocs = documents && documents.length > 0
    ? documents.map(({ content }) => content).join("\n\n")
    : "";

  const newLastMessage = {
    role: "user",
    content: `
    Answer to my question: ${lastMessage.content}

    Using this documents:
    ${injectedDocs}
    `,
  };

  const newMessages = messages.slice(0, -1);
  newMessages.push(newLastMessage);

  const completion = await openai.chat.completions.create({
    messages: [...newMessages],
    model: "gpt-3.5-turbo",
  });

  return new Response(
    JSON.stringify({
      role: "assistant",
      content: completion.choices[0].message.content,
    }),
    { headers: { "Content-Type": "application/json" } },
  );
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/chat' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
