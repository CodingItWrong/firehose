# frozen_string_literal: true

require 'link_parser'
require 'web_mentioner'

class LinksController < ApplicationController
  before_action :authenticate_user!

  def index
    @links = Link.unread.in_move_order
  end

  def show
    @link = Link.find(params[:id])
  end

  def new
    @link = Link.new
  end

  def create
    @link = Link.new(new_link_params)

    if @link.save
      redirect_to links_path
    else
      render :new
    end
  end

  def edit
    @link = Link.find(params[:id])
  end

  def update
    @link = Link.find(params[:id])

    publishing = (!@link.public? && params[:link][:public] == '1')

    if @link.update(edit_link_params)
      publishing && send_web_mention(@link)
      redirect_to(@link.read? ? read_links_path : links_path)
    else
      render :edit
    end
  end

  def destroy
    Link.delete(params[:id])
    respond_to do |format|
      format.html { redirect_to links_path }
      format.json { render json: { success: true } }
    end
  end

  private

  def link_parser
    LinkParser
  end

  def web_mentioner
    WebMentioner
  end

  def new_link_params
    params.require(:link)
          .permit(:url)
          .tap { |params|
            link = link_parser.process(url: params[:url])
            params.merge!(title: link.title, url: link.canonical)
          }
  end

  def edit_link_params
    params.require(:link)
          .permit(:title, :comment, :public, :source, :tag_list)
  end

  def send_web_mention(link)
    web_mentioner.send_mention(link_url(link))
  end
end
