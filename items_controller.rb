class ItemsController < ApplicationController
  extend ActiveSupport::Concern

  def index
    @items = Item.all.to_a
  end

  def show
    @@item = Item.find_by_sql("SELECT * FROM items WHERE id = '#{params[:id]}'").order(name: :asc)
  end

  def create
    @item = Item.new
    @item.update_attributes(params['item'])
  end

  def update
    @item = Item.find_by_sql("SELECT * FROM items WHERE id = '#{params[:id]}'")
    @Item.update_attributes(params['item'])
  end

  def destroy
    @item = Item.find_by_sql("SELECT * FROM items WHERE id = '#{params[:id]}'")
    @item.attachments.unscoped.each { |a|  a.delete }
    @item.destroy
  end

  def user_comments
    items = Item.all
    comments = items.map { |items|  items.comments }.flatten
    @user_comments = comments.select { |comment|  comment.user_id == params[:user_id] }
  end
end

class Item < ActiveRecord::Base
  default_scope { order(id: :asc) }

  has_many :attachments, ->{ where(active: true) }
  has_many :comments
end