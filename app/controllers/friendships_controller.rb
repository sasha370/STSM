class FriendshipsController < ApplicationController
  def create
    friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: friend.id)
    if current_user.save
      flash[:notice] = "Вы успешно подписались на #{friend.first_name}"
    else
      flash[:alert] = "Что-то пошло не так"
    end
    redirect_to my_friends_path
  end

  def destroy
    friendship = current_user.friendships.where(friend_id: params[:id]).first
    friendship.delete
    flash[:notice]= "Вы отписались"
    redirect_to my_friends_path
  end
end
