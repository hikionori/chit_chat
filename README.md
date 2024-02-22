# ChitChat
> This is one of my first Flutter projects that uses Supabase as a backend. Some areas of the code are not optimized and can be improved. This project is just a prototype and not for production.
> If you find any bugs or have any suggestions, please let me know.

## Description
ChitChat is a simple AI Chat with RAG. This project just a prototype and not for production.
For use this project in production you need to rewrite some backend code to make it faster and more efficient.

## Installation

Before you start, you need to install some tools.
1. Supabase
2. Flutter

When you have installed the tools, you can start the installation process.

1. Clone this repository
2. Open the terminal and navigate to the project folder
3. Run `flutter pub get`
4. In `main.dart` code change the `supabaseUrl` and `supabaseKey` to your Supabase project URL and key, or add data local server. Usually this is: `http://127.0.0.1:54321` and `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0`. (DONT USE THIS DATA IN PRODUCTION).
5. Run `supabase start && supabase functions serve` and wait until the server is running
6. In the new terminal, run `flutter run`
