class HomeController < ApplicationController
  require 'axlsx'
  
  def index
    @users = fetch_users(params[:filter], params[:sort], params[:direction])

    @pagy, @users = pagy_array(@users, limit: 10)
  end

  def export
    @users = fetch_users(params[:filter], params[:sort], params[:direction])

    p = Axlsx::Package.new
    wb = p.workbook

    wb.add_worksheet(name: "Users") do |sheet|
      sheet.add_row ["First Name", "Last Name", "Email", "Phone", "Status"]
      @users.each do |user|
        sheet.add_row [user[:first_name], user[:last_name], user[:email], user[:phone], user[:status] ? 'accepted' : '']
      end
    end

    send_data p.to_stream.read, filename: "users.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  private

  def fetch_users(filter = nil, sort = nil, direction = nil)
    users = [
      { first_name: "Alice", last_name: "Schtark", email: "alice@example.com", phone: "9814729142", status: true },
      { first_name: "Bob", last_name: "Denboe", email: "bob@example.com", phone: "9814729242", status: false },
      { first_name: "Charlie", last_name: "Tarkis", email: "charlie@example.com", phone: "9814259142", status: true  },
      { first_name: "David", last_name: "Smith", email: "david@example.com", phone: "9814729342", status: true  },
      { first_name: "Eve", last_name: "Johnson", email: "eve@example.com", phone: "9814729442", status: false  },
      { first_name: "Frank", last_name: "Brown", email: "frank@example.com", phone: "9814729542", status: false  },
      { first_name: "Grace", last_name: "Davis", email: "grace@example.com", phone: "9814729642", status: false  },
      { first_name: "Hank", last_name: "Miller", email: "hank@example.com", phone: "9814729742", status: true  },
      { first_name: "Ivy", last_name: "Wilson", email: "ivy@example.com", phone: "9814729842", status: true  },
      { first_name: "Jack", last_name: "Moore", email: "jack@example.com", phone: "9814729942", status: true  },
      { first_name: "Karen", last_name: "White", email: "karen@example.com", phone: "9814730042", status: false },
      { first_name: "Leo", last_name: "Green", email: "leo@example.com", phone: "9814730142", status: true },
      { first_name: "Mia", last_name: "Hall", email: "mia@example.com", phone: "9814730242", status: false },
      { first_name: "Nina", last_name: "King", email: "nina@example.com", phone: "9814730342", status: true },
      { first_name: "Oscar", last_name: "Scott", email: "oscar@example.com", phone: "9814730442", status: true },
      { first_name: "Paul", last_name: "Young", email: "paul@example.com", phone: "9814730542", status: false },
      { first_name: "Quinn", last_name: "Adams", email: "quinn@example.com", phone: "9814730642", status: true },
      { first_name: "Rachel", last_name: "Baker", email: "rachel@example.com", phone: "9814730742", status: false },
      { first_name: "Sam", last_name: "Clark", email: "sam@example.com", phone: "9814730842", status: true },
      { first_name: "Tina", last_name: "Evans", email: "tina@example.com", phone: "9814730942", status: true },
      { first_name: "Uma", last_name: "Foster", email: "uma@example.com", phone: "9814731042", status: false },
      { first_name: "Victor", last_name: "Garcia", email: "victor@example.com", phone: "9814731142", status: true },
      { first_name: "Wendy", last_name: "Harris", email: "wendy@example.com", phone: "9814731242", status: false },
      { first_name: "Xander", last_name: "Irwin", email: "xander@example.com", phone: "9814731342", status: true },
      { first_name: "Yara", last_name: "Jackson", email: "yara@example.com", phone: "9814731442", status: true },
      { first_name: "Zane", last_name: "Klein", email: "zane@example.com", phone: "9814731542", status: false },
      { first_name: "Amy", last_name: "Lopez", email: "amy@example.com", phone: "9814731642", status: true },
      { first_name: "Brian", last_name: "Martinez", email: "brian@example.com", phone: "9814731742", status: false },
      { first_name: "Cathy", last_name: "Nelson", email: "cathy@example.com", phone: "9814731842", status: true },
      { first_name: "Derek", last_name: "Olsen", email: "derek@example.com", phone: "9814731942", status: true },
      { first_name: "Ella", last_name: "Perez", email: "ella@example.com", phone: "9814732042", status: false }
    ]

    if params[:filter].present?
      filter = params[:filter].downcase
      users = users.select do |user|
        user[:first_name].downcase.include?(filter) ||
        user[:last_name].downcase.include?(filter) ||
        user[:email].downcase.include?(filter)
      end
    end

    if params[:sort].present?
      users = users.sort_by { |user| user[params[:sort].to_sym] }
      users.reverse! if params[:direction] == "desc"
    end

    users
  end
end
