// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { createClient } from "npm:@supabase/supabase-js";
import { multiParser } from "https://deno.land/x/multiparser@0.114.0/mod.ts";

Deno.serve(async (req) => {
  if (req.method == "OPTIONS") {
    return new Response(
      JSON.stringify({
        message: "OK",
      }),
      {
        headers: {
          "Access-Control-Allow-Origin": "*",
        },
      },
    );
  }

  if (req.method === "POST") {
    // return list of chats

    try {
      const supabaseClient = createClient(
        Deno.env.get("SUPABASE_URL") ?? "",
        Deno.env.get("SUPABASE_ANON_KEY") ?? "",
        {
          global: {
            headers: { Authorization: req.headers.get("Authorization") ?? "" },
          },
        },
      );

      const body = await req.json();
      console.log("Body: ", body);

      const { data, error } = await supabaseClient.from("chats").select("*");

      if (error) {
        console.error("Error: ", error);
        return new Response(
          JSON.stringify({
            message: "Error fetching chats",
          }),
          { headers: { "Content-Type": "application/json" } },
        );
      }

      console.log("Data: ", data);

      return new Response(
        JSON.stringify(data),
        { headers: { "Content-Type": "application/json" } },
      );
    } catch (error) {
      console.error("Error: ", error);
      return new Response(
        JSON.stringify({
          message: "Error fetching chats",
        }),
        { headers: { "Content-Type": "application/json" } },
      );
    }
  }

  return new Response(
    JSON.stringify({
      message: "Hello from Functions!",
    }),
    { headers: { "Content-Type": "application/json" } },
  );
});

/* To invoke locally:

  1. Run `supabase start` (see: https://supabase.com/docs/reference/cli/supabase-start)
  2. Make an HTTP request:

  curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/chats' \
    --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
    --header 'Content-Type: application/json' \
    --data '{"name":"Functions"}'

*/
