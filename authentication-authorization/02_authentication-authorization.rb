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
    Authorization.new(current_user).list_posts?
    # logic to return blog posts
  end

  desc 'Fetch all users'
  get 'users' do
    Authorization.new(current_user).list_users?
    # logic to return users
  end

  desc 'Update user'
  params do
    optional :name
    optional :role, values: %i(user admin super_admin)
  end
  put 'user/:id' do
    user = User.find(params[:id])
    Authorization.new(current_user).modify_user?(user, params)
    # logic to return users
  end
end

class Authorization
  ROLE_ALLOWLIST = {
    user: [],
    admin: %i(user admin),
    super_admin: %i(user admin super_admin),
  }

  def initialize(current_user)
    @current_user = current_user
  end

  def list_posts?
    # always allowed, also for guests
    true
  end

  def list_current_users?
    # allowed for logged in users
    @current_user.present?
  end

  def modify_current_user?(user, params)
    # always allowed for super admins
    return true if @current_user.super_admin?

    # allowed for admins if it's not the super_admin role
    # please note that we use an allow-list instead of a deny-list
    # this ensures we don't introduce another role and it can automatically be exploited
    if @current_user.admin? &&
        @current_user.organization == user.organization &&
        ROLE_ALLOWLIST[:admin].includes?(params[:role])
      return true
    end

    # allow a user to modify themselves, but not if a role was specified
    if @current_user.user? &&
        @current_user == user &&
        ROLE_ALLOWLIST[:user].includes?(params[:role])
      true
    end

    false
  end
end
