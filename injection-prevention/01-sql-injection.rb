####################
# Example 1
####################
# Bad:
#  Allows an attacker to set GET param like this and fetch anything:
#  ?id=1;SELECT * FROM credit_cards;
query = User.where("id = #{params[:id]}")

# Good:
#  Use the frameworks escaping possibilities
query = User.where(id: params[:id])
# OR
query = User.where("id = #{sql_escape(params[:id])}")


####################
# Example 2
####################
# Bad:
#  Allows an attacker to set GET param like this and fetch anything:
#  ?sort_field=id&sort_direction=DESC;SELECT * FROM credit_cards;
field = params[:sort_field]
direction = params[:sort_direction]
query = User.where(id: params[:id]).order("#{field} #{direction}")

# Good:
#  Use an allow-list and mapping to prevent injection
ALLOWED_FIELDS = ["id", "name"]
DIRECTION_MAPPING = { "up" => :asc, "down" => :desc }

fail "Field not allowed" unless ALLOWED_FIELDS.include?(field)

direction = DIRECTION_MAPPING.fetch(direction, :asc)

query = User.where(id: params[:id]).order(field => direction)
