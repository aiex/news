class RssLinksController < ApplicationController
  before_filter :find_rss, only: [:show, :edit, :update, :destroy]
  # GET /lists
  # GET /rss_links
  # GET /rss_links.json
  def index
    @rss_links = RssLink.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @rss_links }
    end
  end

  # GET /rss_links/1
  # GET /rss_links/1.json
  def show
    @lists = List.select("id, name, rss_link_ids")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @rss_link }
    end
  end

  # GET /rss_links/new
  # GET /rss_links/new.json
  def new
    @rss_link = RssLink.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @rss_link }
    end
  end

  # GET /rss_links/1/edit
  def edit
  end

  # POST /rss_links
  # POST /rss_links.json
  def create
    @rss_link = RssLink.new(params[:rss_link])

    respond_to do |format|
      if @rss_link.save
        format.html { redirect_to @rss_link, notice: 'Rss link was successfully created.' }
        format.json { render json: @rss_link, status: :created, location: @rss_link }
      else
        format.html { render action: "new" }
        format.json { render json: @rss_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /rss_links/1
  # PUT /rss_links/1.json
  def update
    respond_to do |format|
      if @rss_link.update_attributes(params[:rss_link])
        format.html { redirect_to @rss_link, notice: 'Rss link was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @rss_link.errors, status: :unprocessable_entity }
      end
    end
  end

  def check
    reply = Parser.get_rss_info params[:url]
    render json: reply.to_json
  end

  # DELETE /rss_links/1
  # DELETE /rss_links/1.json
  def destroy
    result = false #@rss_link.destroy

    respond_to do |format|
      format.html {
        return redirect_to rss_link_path(@rss_link, alert: "Unable to destroy Rss link, please try after some time") unless result
        redirect_to rss_links_url
      }
      format.json { head :no_content }
    end
  end

  private
  def find_rss
    @rss_link = RssLink.select("id, title, list_ids, url, description, category_id").find_by_id(params[:id])
    redirect_to rss_links_path, alert: "Rss link not found" unless @rss_link
  end
end
