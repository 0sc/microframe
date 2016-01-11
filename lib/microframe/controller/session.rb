module Microframe
  module Session
    def save_session
      session.each do |key, val|
        response.set_cookie(key, value: val, path: "/")
      end
    end

    def save_flash
    end

    def save_notice
    end

    def save_alert
    end
  end
end
