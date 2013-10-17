# Be sure to restart your server when you modify this file.

require 'action_dispatch/middleware/session/dalli_store'
RemoteAssistant::Application.config.session_store :dalli_store, key: '_RemoteAssistant_session'
