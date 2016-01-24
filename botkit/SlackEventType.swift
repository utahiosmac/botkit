//
//  Event.swift
//  botkit
//
//  Created by Dave DeLong on 1/24/16.
//  Copyright © 2016 Utah iOS & Mac Developers. All rights reserved.
//

import Foundation

public enum SlackEventType: String {
    case Hello                      = "hello"                   // The client has successfully connected to the server
    
    case Message                    = "message"                 // A message was sent to a channel
    case UserTyping                 = "user_typing"             // A channel member is typing a message
    case ChannelMarked              = "channel_marked"          // Your channel read marker was updated
    case ChannelCreated             = "channel_created"         // A team channel was created
    case ChannelJoined              = "channel_joined"          // You joined a channel
    case ChannelLeft                = "channel_left"            // You left a channel
    case ChannelDeleted             = "channel_deleted"         // A team channel was deleted
    case ChannelRenamed             = "channel_rename"          // A team channel was renamed
    case ChannelArchived            = "channel_archive"         // A team channel was archived
    case ChannelUnarchived          = "channel_unarchive"       // A team channel was unarchived
    case ChannelHistoryChanged      = "channel_history_changed" // Bulk updates were made to a channel's history
    
    case DNDUpdated                 = "dnd_updated"             // Do not Disturb settings changed for the current user
    case DNDUpdatedUser             = "dnd_updated_user"        // Do not Disturb settings changed for a team member
    
    case IMCreated                  = "im_created"              // A direct message channel was created
    case IMOpen                     = "im_open"                 // You opened a direct message channel
    case IMClose                    = "im_close"                // You closed a direct message channel
    case IMMarked                   = "im_marked"               // A direct message read marker was updated
    case ImHistoryChanged           = "im_history_changed"      // Bulk updates were made to a DM channel's history
    
    case GroupJoined                = "group_joined"            // You joined a private group
    case GroupLeft                  = "group_left"              // You left a private group
    case GroupOpened                = "group_open"              // You opened a group channel
    case GroupClosed                = "group_close"             // You closed a group channel
    case GroupArchived              = "group_archive"           // A private group was archived
    case GroupUnarchived            = "group_unarchive"         // A private group was unarchived
    case GroupRenamed               = "group_rename"            // A private group was renamed
    case GroupMarked                = "group_marked"            // A private group read marker was updated
    case GroupHistoryChanged        = "group_history_changed"   // Bulk updates were made to a group's history
    
    case FileCreated                = "file_created"            // A file was created
    case FileShared                 = "file_shared"             // A file was shared
    case FileUnshared               = "file_unshared"           // A file was unshared
    case FileMadePublic             = "file_public"             // A file was made public
    case FileMadePrivate            = "file_private"            // A file was made private
    case FileChanged                = "file_change"             // A file was changed
    case FileDeleted                = "file_deleted"            // A file was deleted
    case FileCommentAdded           = "file_comment_added"      // A file comment was added
    case FileCommentEdited          = "file_comment_edited"     // A file comment was edited
    case FileCommentDeleted         = "file_comment_deleted"    // A file comment was deleted
    
    case PinAdded                   = "pin_added"               // A pin was added to a channel
    case PinRemoved                 = "pin_removed"             // A pin was removed from a channel
    
    case PresenceChange             = "presence_change"         // A team member's presence changed
    case ManualPresenceChange       = "manual_presence_change"  // You manually updated your presence
    
    case UserPreferenceChanged      = "pref_change"             // You have updated your preferences
    case UserProfileChanged         = "user_change"             // A team member's data has changed
    case NewMemberJoined            = "team_join"               // A new team member has joined
    
    case StarAdded                  = "star_added"              // A team member has starred an item
    case StarRemoved                = "star_removed"            // A team member removed a star
    case ReactionAdded              = "reaction_added"          // A team member has added an emoji reaction to an item
    case ReactionRemoved            = "reaction_removed"        // A team member removed an emoji reaction
    
    case EmojiChanged               = "emoji_changed"           // A team custom emoji has been added or changed
    case CommandsChanged            = "commands_changed"        // A team slash command has been added or changed
    case TeamPlanChanged            = "team_plan_change"        // The team billing plan has changed
    case TeamPreferenceChanged      = "team_pref_change"        // A team preference has been updated
    case TeamRenamed                = "team_rename"             // The team name has changed
    case TeamDomainChanged          = "team_domain_change"      // The team domain has changed
    case EmailDomainChanged         = "email_domain_changed"    // The team email domain has changed
    case TeamProfileChanged         = "team_profile_change"     // Team profile fields have been updated
    case TeamProfileDeleted         = "team_profile_delete"     // Team profile fields have been deleted
    case TeamProfileReordered       = "team_profile_reorder"    // Team profile fields have been reordered
    
    case BotAdded                   = "bot_added"               // An integration bot was added
    case BotChanged                 = "bot_changed"             // An integration bot was changed
    case AccountsChanged            = "accounts_changed"        // The list of accounts a user is signed into has changed
    case TeamMigrationStarted       = "team_migration_started"  // The team is being migrated between servers
    case SubteamCreated             = "subteam_created"         // A user group has been added to the team
    case SubteamUpdated             = "subteam_updated"         // An existing user group has been updated or its members changed
    case SubteamSelfAdded           = "subteam_self_added"      // You have been added to a user group
    case SubteamSelfRemoved         = "subteam_self_removed"    // You have been removed from a user group
}
