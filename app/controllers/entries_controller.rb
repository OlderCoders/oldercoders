class EntriesController < ApplicationController

  before_action :logged_in_account, except: %i[index show]
  before_action :set_type
  before_action :set_entry, only: %i[show edit update destroy]

  def index
    @entries = entry.all
  end

  def show
  end

  def new
    @entry = entry.new(type: type)
  end

  def create
    @entry = entry.new entry_params.merge(type: type, author: current_account)
    if @entry.save
      flash[:success] = "Object successfully created"
      redirect_to @entry
    else
      flash[:error] = "Something went wrong"
      render 'new'
    end
  end

  private

    def entry_params
      params.require(type.underscore.to_sym).permit(:title, :content)
    end

    def set_type
      @type = type
    end

    def type
      Entry.types.include?(params[:type]) ? params[:type] : "Entry"
    end

    def entry
      type.constantize
    end

    def set_entry
      @entry = entry.with_author.find_by(slug: params[:slug])
    end
end
