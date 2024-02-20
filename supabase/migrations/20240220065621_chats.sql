create extension if not exists vector;

create type _role as enum ('user', 'bot');

create table chats (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references auth.users (id) not null default auth.uid(),
    chat_name text not null,
    created_at timestamp with time zone not null default now(),
    updated_at timestamp with time zone not null default now()
);

create table chat_messages (
    id uuid primary key default gen_random_uuid(),
    chat_id uuid references chats(id) not null,
    role _role not null,
    message text not null,
    embedding vector(512),
    created_at timestamp with time zone not null default now(),
    updated_at timestamp with time zone not null default now()
);

alter table chat_messages add constraint check_valid_role check (role in ('user', 'bot'));
alter table chats enable row level security;
alter table chat_messages enable row level security;

create policy "Users can create new chats" on chats for insert to authenticated with check (auth.uid() = user_id);
create policy "Users can view their chats" on chats for select to authenticated using (auth.uid() = user_id);
create policy "Users can delete their chats" on chats for delete to authenticated using (auth.uid() = user_id);

create policy "Users can create new chat messages" on chat_messages for insert to authenticated with check (
    auth.uid() in (
        select user_id from chats where id = chat_id and role = 'user'
    )
);

create policy "Users can view their chat messages" on chat_messages for select to authenticated using (
    auth.uid() = (select user_id from chats where id = chat_id)
);

create policy "Users can delete their chat messages" on chat_messages for delete to authenticated using (
    auth.uid() = (select user_id from chats where id = chat_id)
);
