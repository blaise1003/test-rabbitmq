require 'fcm'

class FcmHelper

  def initialize(api_key)
    super()
    @device_ids = []
    @key = api_key
  end

  def add_device(device_id)
    @device_ids << device_id
  end

  def send_message_web(title, body, icon, click_action)
    raise 'device ids missing!' if @device_ids.empty?
    message = create_raw_message_web(title, body, icon, click_action)
    fcm = FCM.new(@key)
    response = fcm.send(@device_ids, message)
  end

  def send_message_android(title, body, icon, click_action)
    raise 'device ids missing!' if @device_ids.empty?
    message = create_raw_message_anroid(title, body, icon, click_action)
    fcm = FCM.new(@key)
    response = fcm.send(@device_ids, message)
  end

  private

  def create_raw_message_web(title, body, icon, click_action)
    {
        'notification' =>
            {
                'title' => title,
                'body'  => body,
                'icon'  => icon,
                'click_action' => click_action
            },
        'data' =>
            {
                'lol' => '1',
                'wt'  => '2'
            },
        'time_to_live' => 3,
        'priority' => 'high'
    }
  end

  def create_raw_message_anroid(title, body, icon, click_action)
    {
        'data' => {
            'custom' => {
                'i' => "#{DateTime.now.strftime('%Q')}",
                'a' => {
                    'offercontainer-slug' => click_action.split('/').last,
                    'large-icon-url' => icon,
                    'is-coupon' => 'false',
                    'retailer-slug' => click_action.split('/')[-2],
                    'cmd' => 'open_offer_container',
                    'is-coupon' => false,
                }
            },
            'alert' => body,
            'title' => title
        },
        'small_icon' => 'placeholder_promoqui',
        'large_icon' => icon,
        'android_led_color' => '0043B3',
        'android_accent_color' => '0043B3',
        'android_visibility' => 'Public',
        'android_sound' => 'default',
        'isAndroid' => true
    }
  end

  def create_raw_message_ios(title, body, icon, click_action)
    {
        'notification' =>
            {
                'title' => title,
                'body'  => body,
                'icon'  => icon,
                'click_action' => click_action
            },
        'data' =>
            {
                'lol' => '1',
                'wt'  => '2'
            },
        'time_to_live' => 3,
        'priority' => 'high'
    }
  end
end
