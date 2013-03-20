class ListsController < ApplicationController
  before_filter :find_list, only: [:show, :edit, :update, :destroy, :news_feeds]
  # GET /lists
  # GET /lists.json
  def index
    @lists = List.select("id, name, rss_link_ids").order("updated_at DESC").page(params[:page]).per(10)
    @rss_links = RssLink.select("id, title").where("id IN (?)", @lists.map(&:rss_link_ids).flatten) unless (@lists.empty? || @lists.map(&:rss_link_ids).flatten.empty?)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lists }
    end
  end

  def manage_list_rss_association
    puts "\n" * 5
    puts params[:list_id], params[:rss_id], params[:flag]
    puts "\n" * 5
    response = List.manage_list_rss_association(params[:list_id], params[:rss_id], (params[:flag] == "1" ? 'add' : 'remove'))
    render json: response
  end

  # GET /lists/1
  # GET /lists/1.json
  def show
    @rss_links = RssLink.select("id, title")

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @list }
    end
  end

  # GET /lists/new
  # GET /lists/new.json
  def new
    @list = List.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @list }
    end
  end

  def news_feeds
    @news_feeds = NewsFeed.where("rss_id IN (?)", @list.rss_link_ids).includes(:rss_link).order("updated_at DESC").page(params[:page]).per(20)
    @recent_lists = List.select("id, name").order("updated_at DESC")
    respond_to do |format|
      format.html # index.html.erb
      format.js { render template: '/news_feeds/index.js.erb' }
    end
  end

  # GET /lists/1/edit
  def edit
    @list = List.select("id, name, rss_link_ids").find_by_id(params[:id])
  end

  # POST /lists
  # POST /lists.json
  def create
    @list = List.new(params[:list])

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: 'List was successfully created.' }
        format.json { render json: @list, status: :created, location: @list }
      else
        format.html { render action: "new" }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lists/1
  # PUT /lists/1.json
  def update
    respond_to do |format|
      if @list.update_attributes(params[:list])
        format.html { redirect_to @list, notice: 'List was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    result = @list.destroy
    respond_to do |format|
      format.html {
        return redirect_to list_path(@list, alert: "Unable to destroy list, please try after some time") unless result
        redirect_to lists_url
      }
      format.json { head :no_content }
    end
  end

  private
  def find_list
    @list = List.select("id, name, rss_link_ids").find_by_id(params[:id])
    redirect_to lists_path, alert: "List not found" unless @list
  end
end
