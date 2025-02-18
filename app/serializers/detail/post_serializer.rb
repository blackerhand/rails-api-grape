module Detail
  class PostSerializer < List::PostSerializer
    attributes :desc

    lazy_belongs_to :owner
  end
end
