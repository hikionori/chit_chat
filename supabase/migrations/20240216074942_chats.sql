create type role as enum ('user', 'ai');

create table chats (                                  
    id uuid primary key default uuid_generate_v4(),     
    user_id uuid not null references auth.users(id) default auth.uid(),
    title text not null,
    created_at timestamp with time zone default now(),                    
    updated_at timestamp with time zone default now()                 
);

create table chat_message (
    id uuid primary key default uuid_generate_v4(),
    chat_id uuid not null references chats(id) on delete cascade,
    message_role role not null default 'user',
    message_text text not null,
    created_at timestamp with time zone default now()
);

create table chat_documents (
    id bigint primary key generated always as identity,
    chat_id uuid not null references chats(id) on delete cascade,
    document_id bigint not null references documents(id) on delete cascade
);

alter table chats enable row level security;
alter table chat_message enable row level security;

-- policy
-- Users can insert chats
create policy "Authenticated can insert chats" on chats for insert to authenticated with check (
    user_id = auth.uid()
);

-- Users can view their own chats
create policy "Users can view their own chats" on chats for select to authenticated using (
    user_id = auth.uid()
);

-- Users can delete their own chats
create policy "Users can delete their own chats" on chats for delete to authenticated using (
    user_id = auth.uid()
);

-- Users can update their own chats
create policy "Users can update their own chats" on chats for update to authenticated using (
    user_id = auth.uid()
);

-- Users can insert chat_message
create policy "Users can insert chat_message" on chat_message for insert to authenticated with check (
    chat_id in (
        select id from chats where user_id = auth.uid()
    )
);

-- Users can view their own chat_message
create policy "Users can view their own chat_message" on chat_message for select to authenticated using (
    chat_id in (
        select id from chats where user_id = auth.uid()
    )
);

-- Users can delete their own chat_message
create policy "Users can delete their own chat_message" on chat_message for delete to authenticated using (
    chat_id in (
        select id from chats where user_id = auth.uid()
    )
);

-- Users can insert chat_documents
CREATE POLICY "Users can insert chat_documents" ON chat_documents FOR INSERT TO authenticated WITH CHECK (
    chat_id IN (
        SELECT id FROM chats WHERE user_id = auth.uid()
    ) AND
    document_id IN (
        SELECT id FROM documents WHERE created_by = auth.uid()
    )
);

-- Users can view their own chat_documents
CREATE POLICY "Users can view their own chat_documents" ON chat_documents FOR SELECT TO authenticated USING (
    chat_id IN (
        SELECT id FROM chats WHERE user_id = auth.uid()
    ) AND
    document_id IN (
        SELECT id FROM documents WHERE created_by = auth.uid()
    )
);

-- Users can delete their own chat_documents
CREATE POLICY "Users can delete their own chat_documents" ON chat_documents FOR DELETE TO authenticated USING (
    chat_id IN (
        SELECT id FROM chats WHERE user_id = auth.uid()
    ) AND
    document_id IN (
        SELECT id FROM documents WHERE created_by = auth.uid()
    )
);