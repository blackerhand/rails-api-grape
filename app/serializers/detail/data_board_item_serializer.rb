module Detail
  class DataBoardItemSerializer < List::DataBoardItemSerializer
    attributes :available_sub_single_scopes, :available_sub_stat_scopes

    attribute :query_params do
      object.main_data_board_indicator.query_params
    end

    attribute :query_data do
      DataBoards::QueryItem.execute(object)
    end

    render_record :main_data_board_indicator
    render_record :sub_data_board_indicators
  end
end
