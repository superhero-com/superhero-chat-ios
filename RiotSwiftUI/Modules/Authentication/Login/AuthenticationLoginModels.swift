//
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

// MARK: View model

enum AuthenticationLoginViewModelResult {
    /// The user would like to select another server.
    case selectServer
    /// Parse the username and update the homeserver if included.
    case parseUsername(String)
    /// The user would like to reset their password.
    case forgotPassword
    /// Login using the supplied credentials.
    case login(username: String, password: String)
    /// Continue using the supplied SSO provider.
    case continueWithSSO(SSOIdentityProvider)
}

// MARK: View

struct AuthenticationLoginViewState: BindableState {
    /// Data about the selected homeserver.
    var homeserver: AuthenticationHomeserverViewData
    /// Whether a new homeserver is currently being loaded.
    var isLoading: Bool = false
    /// View state that can be bound to from SwiftUI.
    var bindings: AuthenticationLoginBindings
    
    /// Whether to show any SSO buttons.
    var showSSOButtons: Bool {
        !homeserver.ssoIdentityProviders.isEmpty
    }
    
    /// `true` if it is possible to continue, otherwise `false`.
    var hasValidCredentials: Bool {
        !bindings.username.isEmpty && !bindings.password.isEmpty
    }
}

struct AuthenticationLoginBindings {
    /// The username input by the user.
    var username = ""
    /// The password input by the user.
    var password = ""
    /// Information describing the currently displayed alert.
    var alertInfo: AlertInfo<AuthenticationLoginErrorType>?
}

enum AuthenticationLoginViewAction {
    /// The user would like to select another server.
    case selectServer
    /// Parse the username to detect if a homeserver is included.
    case parseUsername
    /// The user would like to reset their password.
    case forgotPassword
    /// Continue using the input username and password.
    case next
    /// Continue using the supplied SSO provider.
    case continueWithSSO(SSOIdentityProvider)
}

enum AuthenticationLoginErrorType: Hashable {
    /// An error response from the homeserver.
    case mxError(String)
    /// The current homeserver address isn't valid.
    case invalidHomeserver
    /// The response from the homeserver was unexpected.
    case unknown
}
