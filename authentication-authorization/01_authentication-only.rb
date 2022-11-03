class Base
  before do
    auth_optional = routes[0]&.settings&.dig(:authentication, :optional)

    if auth_optional
      Rails.logger.info 'Authentication optional for this endpoint'
    else
      authenticate!
    end
  end

  desc 'Fetch all blog posts'
  route_setting :authentication, optional: 'Everyone is allowed to read blog posts'
  get 'posts' do
    # logic to return blog posts
  end

  desc 'Fetch all users'
  get 'users' do
    # logic to return users
  end
end
