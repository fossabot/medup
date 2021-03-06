module Medium
  class Client
    module Posts
      def posts
        u = user
        user_id = u["user"]["userId"]
        result = [] of Hash(String, JSON::Any)

        params : Hash(String, String)? = {"limit" => "100"}
        stream_url = "/_/api/users/#{user_id}/profile/stream"
        while params
          response = get(stream_url, params: params)
          records = response["payload"]["references"]["Post"]

          records.raw.as(Hash).each do |k, post|
            result << post.raw.as(Hash)
          end

          next_page = response["payload"]["paging"]["next"]?
          break if next_page.nil?

          params["page"] = next_page["page"].raw.to_s
          params["to"] = next_page["to"].raw.to_s
        end

        result
      end

      def post(post_id : String)
        response = get("/@#{@user}/#{post_id}")
        response["payload"]["value"]
      end
    end
  end
end
