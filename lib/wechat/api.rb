require 'wechat/api_base'
require 'wechat/http_client'
require 'wechat/token/public_access_token'
require 'wechat/ticket/public_jsapi_ticket'
require 'wechat/concern/common'

module Wechat
  class Api < ApiBase
    include Concern::Common
    DEVICE_BASE = 'https://api.weixin.qq.com/device/'.freeze

    def qrcode_create_scene_str(scene_id, expire_seconds = 604800)
      post 'qrcode/create', JSON.generate(expire_seconds: expire_seconds,
                                          action_name: 'QR_STR_SCENE',
                                          action_info: { scene: { scene_str: scene_id } })
    end

    def template_message_send(message)
      post 'message/template/send', message.to_json, content_type: :json
    end

    def list_message_template
      get 'template/get_all_private_template'
    end

    def add_message_template(template_id_short)
      post 'template/api_add_template', JSON.generate(template_id_short: template_id_short)
    end

    def del_message_template(template_id)
      post 'template/del_private_template', JSON.generate(template_id: template_id)
    end

    def device_bind(open_id, device_id)
      client.post 'compel_bind', JSON.generate(device_id: device_id,
                                                openid:open_id), base: DEVICE_BASE, access_token: access_token.token
    end

    def device_unbind(open_id, device_id)
      client.post 'compel_unbind', JSON.generate(device_id: device_id,
                                                openid:open_id), base: DEVICE_BASE, access_token: access_token.token
    end

    def device_transmsg(device_type, open_id, device_id, content)
      client.post 'transmsg', JSON.generate(device_type: device_type, open_id: open_id,
                                            device_id: device_id, content: content), base: DEVICE_BASE, access_token: access_token.token
    end

    def device_authorize(device_num, device_list, op_type, product_id)
      client.post 'authorize_device', JSON.generate(device_num: device_num, device_list: device_list,
                                                    op_type: op_type, product_id: product_id), base: DEVICE_BASE, access_token: access_token.token
    end
  end
end
