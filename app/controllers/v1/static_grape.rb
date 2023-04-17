module V1
  class StaticGrape < PubGrape
    desc '首页' do
      summary '首页'
      detail '首页'
      tags ['static']
    end
    get '/' do
      { status: 'ok' }
    end
  end
end
