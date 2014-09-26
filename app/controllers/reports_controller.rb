class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy]
  LEGATO_OAUTH_CLIENT_ID='941417668948-sm0mnqcrvnojqanmn1ji9969sihkam74.apps.googleusercontent.com'
  LEGATO_OAUTH_SECRET_KEY='RITCXfzU8B-NHaH2pKfYmFKt'

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.all
    google_access_token
  end

  # GET client auth token
  # GET response json
  def google_access_token
    $client = OAuth2::Client.new(LEGATO_OAUTH_CLIENT_ID, LEGATO_OAUTH_SECRET_KEY, {
      :authorize_url => 'https://accounts.google.com/o/oauth2/auth',
      :token_url => 'https://accounts.google.com/o/oauth2/token'
    })
    @url = $client.auth_code.authorize_url({
      :scope => 'https://www.googleapis.com/auth/analytics.readonly',
      :redirect_uri => 'http://localhost:3000/oauth2callback',
      :access_type => 'offline'
    })
    redirect_to @url
  end

  # GET access auth token
  # GET response json
  def outh_response
    @reports = Report.all
    users = []
    names = []
    begin
      access_token = $client.auth_code.get_token(params[:code], :redirect_uri => 'http://localhost:3000/oauth2callback')
      @response_json = access_token.get('https://www.googleapis.com/analytics/v3/management/accounts').body
      user = Legato::User.new(access_token)
      profile = user.profiles.first
      @users = Report.get_user_count(profile, 9.day.ago, 0.day.ago)
      @sessions = Report.get_session_count(profile, 9.day.ago, 0.day.ago)
      @pageviews = Report.get_pageview(profile, 9.day.ago, 0.day.ago)
      @name = user.profiles.map(&:name).first
      @names = user.profiles.map(&:name)
      render :index
    rescue
      respond_to do |format|
        format.html {render :index, alert: 'Analytics not found.' }
      end
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        format.html { redirect_to @report, notice: 'Report was successfully created.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:page_view, :sessions, :date, :site_id)
    end
end
