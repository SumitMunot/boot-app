json.array!(@reports) do |report|
  json.extract! report, :id, :page_view, :sessions, :date, :site_id
  json.url report_url(report, format: :json)
end
