// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// console.log("Hello from Functions!");

Deno.serve(async (req) => {
  const { messages }: {
    messages: {
      content: string;
      role: string;
    }[];
  } = await req.json();

  // get last message
  const lastMessage = messages[messages.length - 1];
  // create embedding
  // match documents with this embedding
  // return the most similar document
  // send message to openai

  // openai template
  // - get last message content
  // - add documents content
  // send message to openai

  // return response message

  return new Response(
    JSON.stringify({
      role: "assistant",
      content: lastMessage.content,
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
