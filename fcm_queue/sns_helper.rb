require 'aws-sdk'

class SnsHelper

  def initialize
    super
    @sns_region = PqsignalConfig.settings.sns_region
    @sns_topic  = PqsignalConfig.settings.sns_topic
    @device_ids = []
  end

  def add_device(device_id)
    @device_ids << device_id
  end

  def send_message(title, body, icon, click_action)
    raise 'device ids missing!' if @device_ids.empty?
    sns = Aws::SNS::Resource.new(region: @sns_region)
    topic = sns.topic(@sns_topic)
    topic.publish({ message: create_raw_message(title, body, icon, click_action)})
  end

  def self.send_test_message
    sns_helper = SnsHelper.new
    sns_helper.add_device 'dow_bVNxag8:APA91bGMXCFdn6gS82v7bI_GafxQp19yXwaxV4_WxKNOcltpuWCkiDgQVGO-p-w6K7TOgh7-pOpQpkgaaC3vADD7X8cv1amQNpralJajByoZFHEU_zOOnMWqS666u5VvKlfDQZF_rC4C'

    sns_helper.send_message 'title 1',                                                                    # Title
                            'ciao mamma',                                                                 # Body
                            'https://data.promoqui.it/retailers/logos/000/000/050/thumb/mediaworld.jpg',  # Icon
                            'https://www.promoqui.it/volantino/mediaworld/la-tecnologia-e-di-casa-449725' # Click Action
  end

  private

  def create_raw_message(title, body, icon, click_action)
    hash_to_json =
        {
            'recipients' => @device_ids,
            'payload'    =>
                {
                    'notification' =>
                        {
                            'title' => title,
                            'body'  => body,
                            'icon'  => icon,
                            'click_action' => click_action
                        },
                    'data' => #TODO review
                        {
                            'lol' => '1',
                            'wt'  => '2'
                        }
                }
        }
    JSON[hash_to_json]
  end

end
