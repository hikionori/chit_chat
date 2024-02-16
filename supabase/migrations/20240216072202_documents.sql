create extension vector with schema extensions;

create table documents (                                  
    id bigint primary key generated always as identity,                   
    name text not null,                                                   
    storage_object_id uuid not null references storage.objects(id),       
    created_at timestamp with time zone default now(),                    
    created_by uuid not null references auth.users(id) default auth.uid()
);

create view documents_with_storage_path
with (security_invoker=true) as 
select documents.*, storage.objects.name as storage_path
from documents
join storage.objects on documents.storage_object_id = storage.objects.id;

create table document_sections (
    id bigint primary key generated always as identity,
    document_id bigint not null references documents(id),
    content text not null,
    embedding vector(512)
);

create index on document_sections using hnsw (embedding vector_ip_ops);

alter table documents enable row level security;
alter table document_sections enable row level security;

-- policy 
-- Users can insert documents
create policy "Authenticated can insert documents" on documents for insert to authenticated with check (
    created_by = auth.uid()
);

-- Users can view their own documents
create policy "Users can view their own documents" on documents for select to authenticated using (
    created_by = auth.uid()
);

-- Users can delete their own documents
create policy "Users can delete their own documents" on documents for delete to authenticated using (
    created_by = auth.uid()
);

-- Users can update their own documents
create policy "Users can update their own documents" on documents for update to authenticated using (
    created_by = auth.uid()
);

-- Users can insert document_sections
create policy "Users can insert document sections" on document_sections for insert to authenticated with check (
    document_id in (
        select id from documents where created_by = auth.uid()
    )
);

-- Users can update their own document_sections
create policy "Users can update their own document sections" on document_sections for update to authenticated using (
    document_id in (
        select id from documents where created_by = auth.uid()
    ) 
) with check (document_id in (
    select id from documents where created_by = auth.uid()
));

-- Users can delete their own document_sections
create policy "Users can delete their own document sections" on document_sections for delete to authenticated using (
    document_id in (
        select id from documents where created_by = auth.uid()
    ) 
);

