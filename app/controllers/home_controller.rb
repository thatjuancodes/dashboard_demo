class HomeController < ApplicationController
  def index
    @users = [
      { first_name: "Alice", last_name: "Schtark", email: "alice@example.com", phone: "9814729142", status: true },
      { first_name: "Bob", last_name: "Denboe", email: "bob@example.com", phone: "9814729242", status: false },
      { first_name: "Charlie", last_name: "Tarkis", email: "charlie@example.com", phone: "9814259142", status: true  },
      { first_name: "David", last_name: "Smith", email: "david@example.com", phone: "9814729342", status: true  },
      { first_name: "Eve", last_name: "Johnson", email: "eve@example.com", phone: "9814729442", status: false  },
      { first_name: "Frank", last_name: "Brown", email: "frank@example.com", phone: "9814729542", status: false  },
      { first_name: "Grace", last_name: "Davis", email: "grace@example.com", phone: "9814729642", status: false  },
      { first_name: "Hank", last_name: "Miller", email: "hank@example.com", phone: "9814729742", status: true  },
      { first_name: "Ivy", last_name: "Wilson", email: "ivy@example.com", phone: "9814729842", status: true  },
      { first_name: "Jack", last_name: "Moore", email: "jack@example.com", phone: "9814729942", status: true  }
    ]

    if params[:filter].present?
      filter = params[:filter].downcase
      @users = @users.select do |user|
        user[:first_name].downcase.include?(filter) ||
        user[:last_name].downcase.include?(filter) ||
        user[:email].downcase.include?(filter)
      end
    end

    if params[:sort].present?
      @users = @users.sort_by { |user| user[params[:sort].to_sym] }
      @users.reverse! if params[:direction] == "desc"
    end

    @pagy, @users = pagy_array(@users, limit: 5)
  end
end
