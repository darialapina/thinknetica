class Search
  SEARCHABLE_ENTITIES = %w(Question Answer User Comment)

  def self.find(query, search_in='All')
    (search_in.in?(SEARCHABLE_ENTITIES) ? search_in.classify.constantize : ThinkingSphinx ).search ThinkingSphinx::Query.escape(query)
  end
end
