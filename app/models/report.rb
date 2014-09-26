class Report < ActiveRecord::Base
	extend Legato::Model

  metrics :pageviews, :uniquePageviews, :sessions, :users, :newUsers, :exits
  dimensions :pagePathLevel1, :sessionCount, :userType, :userDefinedValue, :operating_system, :browser

  filter(:by_index_in_path_level_1) {|page_path_level1| contains(:pagePathLevel1, 'index')}

  # all reuslts query
  def self.query(profile, start_date, end_date)
    Report.results(profile,
                      :start_date => start_date,
                      :end_date => end_date
    )
    # Just for reference, sorting descending by Report is done by:   :sort => '-Report'
  end

  # query index
  def self.query_index(profile, start_date, end_date)
    Report.by_index_in_path_level_1.results(profile,
                                               :start_date => start_date,
                                               :end_date => end_date
    )
  end

  # get pageviews
  def self.get_pageview(profile, start_date, end_date)
    pageviews = []
    Report.query(profile, start_date, end_date).each do |result|
      # Just print the pageviews & unique-pageviews, for example
      pageviews << result.try(:pageviews)
      # puts result.try(:uniquePageviews)
    end
    pageviews = pageviews.map(&:to_i)
    return pageviews.inject(:+)
  end

  # get session count
  def self.get_session_count(profile, start_date, end_date)
    sessions = []
    Report.query(profile, start_date, end_date).each do |result|
      # Just print the session count
      sessions << result.try(:sessionCount)
    end
    sessions = sessions.map(&:to_i)
    return sessions.inject(:+)
  end

  # get session count
  def self.get_user_count(profile, start_date, end_date)
    users = []
    Report.query(profile, start_date, end_date).each do |result|
      # Just print the session count
      users << result.try(:users)
    end
    users = users.map(&:to_i)
    return users.inject(:+)
  end
end
