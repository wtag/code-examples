# data stored in the database, e.g. in the user table
USER_LIST = [
  { email: 'john@example.org' },
  { email: 'jane@example.org' },
]

class API
  put 'request-reset' do
    # Let's search the user in the database
    user = USER_LIST.find do |user|
      user[:email] == params[:email]
    end

    # If the user is found, send the password reset email
    if user
      SendPasswordResetEmail.call(user)
    end

    # Important:
    # * Always respond with a successful status code
    # * Don't expose the found user details
    status 204
    body nil
  end
end
