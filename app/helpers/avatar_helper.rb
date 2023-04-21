module AvatarHelper
  def cloudinary_avatar(user)
    if user.photo.attached?
      cl_image_path user.photo.key
    else
      asset_path("noPicAvatar.png")
    end
  end

  def navbar_avatar(user)
    if user.photo.attached?
      cl_image_tag user.photo.key, alt: "#{ current_user.first_name } avatar", class: "rounded-circle", height: "32"
    else
      image_tag "noPicAvatar.png", alt: "Sign in or create account", class: "rounded-circle", height: "32"
    end
  end
end
