let g:crosschannel_bluesky_id = 'takets.bsky.social'
let g:crosschannel_bluesky_password = $DSKY_PASSWORD

let g:crosschannel_mastodon_host = $MASTODON_HOST
let g:crosschannel_mastodon_client_name = 'crosschannel-nvim'
let g:crosschannel_mastodon_token = $MASTODON_TOKEN
let g:crosschannel_mastodon_username = $MASTODON_USERNAME
let g:crosschannel_mastodon_password = $MASTODON_PASSWORD

let g:crosschannel_x_consumer_key = $X_CONSUMER_KEY
let g:crosschannel_x_consumer_secret = $X_CONSUMER_SECRET
let g:crosschannel_x_access_token = $X_ACCESS_TOKEN
let g:crosschannel_x_access_token_secret = $X_ACCESS_TOKEN_SECRET
let g:crosschannel_x_bearer_token = $X_BEARER_TOKEN

let g:hashtag = ''
nnoremap <silent> c<CR> :CrossChannelPostSelect mastodon bluesky<CR>