class ApplicationController < ActionController::Base
  # This module helps to protect from CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Before any action is executed, check if the user is authenticated.
  before_action :authenticate_user!

  # Rescue from common exceptions to handle them gracefully
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
  rescue_from ActionController::RoutingError, with: :handle_routing_error
  rescue_from StandardError, with: :handle_standard_error

  # Use custom logging for requests
  around_action :log_request_info

  private

  # Simulating a method for user authentication
  def authenticate_user!
    # Placeholder for actual authentication logic.
    # Redirect or show error if user is not authenticated.
    unless user_signed_in?
      redirect_to login_path, alert: "Please log in to continue."
    end
  end

  # Method to check if user is signed in (stub method for example purposes)
  def user_signed_in?
    # Placeholder for actual signed-in check (e.g., session or token check)
    session[:user_id].present?
  end

  # Handle record not found error
  def handle_record_not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  # Handle routing errors
  def handle_routing_error
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  # Generic error handler for other exceptions
  def handle_standard_error(exception)
    # Log the error
    logger.error "An error occurred: #{exception.message}"
    logger.error exception.backtrace.join("\n")

    # Render a generic 500 error page
    render file: "#{Rails.root}/public/500.html", status: :internal_server_error
  end

  # Custom logger for request information
  def log_request_info
    start_time = Time.now
    logger.info "Processing #{controller_name}##{action_name} - Params: #{params.to_unsafe_h}"

    yield # Continue with the request

    duration = Time.now - start_time
    logger.info "Completed #{controller_name}##{action_name} in #{duration.round(2)}s"
  end
end
