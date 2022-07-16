module ApplicationHelper
  include Pagy::Frontend

  def default_meta_tags
    {
      site: (t 'defaults.app_name'),
      title: (t 'defaults.catch_phrase'),
      reverse: false,
      charset: 'utf-8',
      description: 'マイクで拾った音声をデスボイスに加工し録音するアプリです。※Chrome推奨。Safariなど一部のブラウザやお使いのデバイスによってはうまく録音できない場合があります。',
      keywords: 'デスボイス, デスボ, ボイスチェンジャー, デスボイスチェンジャー',
      canonical: request.original_url,
      separator: '|',
      icon: [
        { href: image_url('favicon.ico') }
      ],
      og: {
        site_name: :site,
        description: :description,
        type: 'website',
        url: :canonical,
        image: image_url('normal_ogp.png'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@tateno2321201',
      }
    }
  end
end
