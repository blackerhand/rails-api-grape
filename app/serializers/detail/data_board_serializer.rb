module Detail
  class DataBoardSerializer < List::DataBoardSerializer
    lazy_has_many :data_board_items
  end
end
