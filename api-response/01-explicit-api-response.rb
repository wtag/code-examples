# data stored in the database, e.g. in the user table
USER_LIST = [
  { full_name: 'John Doe', password_digest: '$1$someStuffHere' },
  { full_name: 'Jane Doe', password_digest: '$1$someDifferentStuff' },
]

class API
  get 'users-unsafe' do
    ##################################
    # This is unsafe, DON'T DO THIS! #
    ##################################
    JSON.pretty_generate USER_LIST
    # returns:
    # [
    #   { "full_name": "John Doe", "password_digest": "$1$someStuffHere" },
    #   { "full_name": "Jane Doe", "password_digest": "$1$someDifferentStuff" }
    # ]
  end

  get 'users-safe' do
    #######################
    # This safe, DO THIS! #
    #######################
    mapped_data = USER_LIST.map do |user|
      { full_name: user[:full_name] }
    end
    JSON.pretty_generate mapped_data
    # returns:
    # [
    #   { "full_name": "John Doe" },
    #   { "full_name": "Jane Doe" },
    # ]
  end
end
