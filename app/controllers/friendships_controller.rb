class FriendshipsController < ApplicationController
  def create
  end

  def destroy
    # отыскиваем нашу Акцию в БД по переданному ID в url
    friendship = current_user.friendships.where(friend_id: params[:id]).first
    friendship.delete
    flash[:notice]= "Вы отписались"
    redirect_to my_friends_path
  end

end
