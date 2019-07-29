class ItemsController < ApplicationController

  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def create
    @item.create(params[:item])
  end

  def update
    @item = Item.find(params[:id])
    @item.update(params[:item])
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
  end

  def user_comments
    @user_comments = Comment.where(user_id: params[:user_id])
  end
end

class Item < ActiveRecord::Base
  default_scope { order(id: :asc) }
  has_many :active_attachments, ->{ where(active: true) } , foreign_key: 'item_id', class_name: 'Attachment'
  has_many :attachments, dependent: :destroy
  has_many :comments
end