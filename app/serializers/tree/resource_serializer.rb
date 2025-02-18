module Tree
  class ResourceSerializer < List::ResourceSerializer
    attribute :children do
      object.children.map do |child|
        record_by_serializer(child, Tree::ResourceSerializer)
      end
    end
  end
end
