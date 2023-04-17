module V1
  class TotalsGrape < SignGrape
    desc '数据看板' do
      summary '数据看板'
      detail '数据看板'
      tags ['totals']
      success Entities::TermStat::Detail
    end
    params do
      requires :term_id, type: Integer, allow_blank: false, desc: '学期 ID'
    end
    get '/term' do
      valid_error!('不允许访问数据看板, 请联系管理员') unless current_user.can_access_totals

      @term_stat = TermStat.where(term_id: params.term_id).last
      data_record!(@term_stat, Entities::TermStat::Detail)
    end
  end
end
