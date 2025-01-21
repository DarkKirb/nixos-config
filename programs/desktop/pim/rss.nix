{ config, ... }:
{
  programs.newsboat = {
    enable = true;
    autoReload = true;
    urls =
      [
        {
          tags = [ "blog" ];
          url = "https://www.5snb.club/rss.xml";
        }
        {
          tags = [ "blog" ];
          url = "https://soatok.blog/feed/";
        }
        {
          tags = [ "blog" ];
          url = "https://cendyne.dev/feed.xml";
        }
        {
          tags = [ "blog" ];
          url = "https://xeiaso.net/blog.rss";
        }
        {
          tags = [ "comic" ];
          url = "https://xkcd.com/atom.xml";
        }
      ]
      ++ (map
        (url: {
          tags = [ "youtube" ];
          inherit url;
        })
        [
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCqDbZac1bo_WEPau9c5R5WQ"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCuCkxoKLYO_EQ2GeFtbM_bw"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCwxrHMcTY7DCJSYCSftJOTA"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UC1dRqPWIjPwcONdV2L1-mrw"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCCWeRTgd79JL0ilH0ZywSJA"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCXnNibvR_YIdyPs8PZIBoEw"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCRHXUZ0BxbkU2MYZgsuFgkQ"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCdnteqJUEFetgKgWItToLHg"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCE5dIscvDxrb7CD5uiJJOiw"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCbtwi4wK1YXd9AyV_4UcE6g"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UC9pVBqtx2-XrSfKn3BwHrXA"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UChIs72whgZI9w6d6FhwGGHA"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UC1D3yD4wlPMico0dss264XA"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCFhXFikryT4aFcLkLw2LBLA"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCYO_jab_esuFRV4b17AJtAw"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCy0tKL1T7wFoYcxCe0xjN6Q"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UClRwC5Vc8HrB6vGx6Ti-lhA"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCWoSKWs8h6lFdiEDAjuIfpA"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCwRqWnW5ZkVaP_lZF7caZ-g"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCk9RA3G-aVQXvp7-Q4Ac9kQ"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCto7D1L-MiRoOziCXK9uT5Q"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCKOvOaJv4GK-oDqx-sj7VVg"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UChFur_NwVSbUozOcF_F2kMg"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCL0EBrPPyepiM_U3CIW-0xw"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCJxsAjbKGzdq9__bqTEf_fQ"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCAnzaHhB0ONtwDkYdc3MFCw"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCo0-VCHchPIG3JtJlIQnFew"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCroqqI7XwD828o0rAvAF8iw"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCQG40havu4kNpB4pxUDQhYQ"
          "https://www.youtube.com/feeds/videos.xml?channel_id=UCKlA7qF9XKwu79ULYmVu28w"
        ]
      );
  };
  home.persistence.default.directories = [ ".local/share/newsboat" ];
}
