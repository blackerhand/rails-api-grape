module Detail
  class ChatSerializer < List::ChatSerializer
    lazy_has_many :messages
    lazy_belongs_to :owner
    lazy_belongs_to :chatable
  end
end
