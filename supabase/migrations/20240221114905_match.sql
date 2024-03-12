-- Matches document sections using vector similarity search on embeddings
--
-- Returns a setof document_sections so that we can use PostgREST resource embeddings (joins with other tables)
-- Additional filtering like limits can be chained to this function call
create or replace function match_document_sections(embedding vector(512), match_threshold float)
returns setof document_sections
language plpgsql
as $$
#variable_conflict use_variable
begin
  return query
  select *
  from document_sections

  where document_sections.embedding <#> embedding < -match_threshold

  order by document_sections.embedding <#> embedding;
end;
$$;