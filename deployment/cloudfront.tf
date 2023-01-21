# This is the cloudfront distribution for the client.
#
# Cloudfront is a CDN (Content Distribution Network) that stores a copy
# of the client in many AWS datacenters across the world. This allows
# us to let users download the website's assets from the closest AWS
# datacenter to them, rather than one that is potentially halfway
# across the world.
#
# It also means that when California finally decides it's had enough of the rest
# of the States' BS and swims off into the atlantic (disconnecting from the rest
# of the world) a copy of the website will still be available for the rest of
# the world, and the isolated datacenters in the New California Republic can
# keep serving the assets to the locals.
#
# Man, I should have been a science fiction writer...
resource "aws_cloudfront_distribution" "www" {
  # The "origin" is the actual data we want to distribute.
  # All of the settings are just telling Cloudfront to look
  # at our S3 bucket and serve it's contents when asked for them.
  origin {
    # This is the "origin" we are going to pull the data from.
    # Here you can see we're really just pointing it at
    # our s3 bucket.
    # When we first create our distribution, Cloudfront
    # will download all the assets from this url and
    # then cache them across the world.
    domain_name = aws_s3_bucket.domain.website_endpoint

    # the id of the "origin". This is only used for other
    # services to be able to reference this origin
    origin_id = local.id_for_cloudfront_origin_www

    # This config describes how cloudfront is going
    # connect to the "origin".
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = [
        "TLSv1",
        "TLSv1.1",
        "TLSv1.2"
      ]
    }
  }

  # since it takes about 15 minutes to create a cloudfront distro,
  # AWS added a feature to "disable" them, instead of delete.
  # If you want to disable the distro, change this to false and
  # `terraform apply` away.
  enabled = true

  # This is the default file to send a client when they hit the root of
  # our cloudfront distro. You can use any filepath here. The best
  # thing to do would probably be to set it to:
  #
  #
  # default_root_object = "${aws_s3_bucket.client_source.website.index_document}"
  #
  #
  # I don't want to do that here because I think it obfuscated
  # the fairly simple concept of how this whole CloudFront thing works.
  #
  # The filepath we provide is going to be relative from the base
  # of our `origin`. Our origin is a file directory that was downloaded
  # from the S3 bucket our assets are in. To prove this is the
  # case I'm going to play a dangerous game and set it like this:
  default_root_object = "index.html"

  # This is the behavior that we will apply to all requests we
  # receive for the content itself.
  default_cache_behavior {
    # if by any chance a user doesn't use HTTPS when
    # they try to connect to this cloudfront distro,
    # we just redirect them to the HTTPS version.
    viewer_protocol_policy = "redirect-to-https"

    # Compress the assets for speeeeeeed
    compress = true

    # HTTP methods we're gonna allow when someone asks for the content.
    allowed_methods = [
      "GET",
      "HEAD"
    ]
    cached_methods = [
      "GET",
      "HEAD"
    ]

    # the origin (aka source) we will serve to people
    # upon request. Same as the origin_id above but
    target_origin_id = local.id_for_cloudfront_origin_www

    # time to live for each cached copy of the
    # source content cloudfront downloads.
    min_ttl = 0

    default_ttl = 86400
    max_ttl     = 31536000

    forwarded_values {
      # if someone asks for a certain path or  provides a query string,
      # that link with the query string will still be seen by our
      # elm app. What this really means is whether cloudfront will cache
      # BASED on these query strings and path. Unless you are pointing
      # at some dynamic origin where content changes often, you probably
      # should just keep this set to false.
      query_string = false

      # This actually does say we don't want to forward cookies to the
      # origin. So if you wanna use any cookies, be sure to change this.
      cookies {
        forward = "none"
      }
    }
  }

  # This is a required field that specifies who is allowed to fetch
  # content from our cloudfront distro. Since we want the website
  # to be available to everyone we put remove all restrictions.
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # this is the list of domains that cloudfront will serve content to.
  # So make sure at least one of them matches your domain.
  aliases = [
    var.domain_name,
    "www.${var.domain_name}",
    "dev.${var.domain_name}",
  ]

  # This is the certificate we will use for HTTPS. We use the
  # same one in our API so we have passed the arn in via an
  # input variable.
  viewer_certificate {
    acm_certificate_arn = var.cert_arn
    ssl_support_method  = "sni-only"
  }

}

# need to make sure we use the same identifier when we
# describe our "origin" (more on that a few lines down) and
# when we configure how cloudfront caches assets
locals {
  id_for_cloudfront_origin_www = var.domain_name
}
