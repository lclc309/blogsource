<div class="copyright" >
  {% set current = date(Date.now(), "YYYY") %}
  &copy; {% if theme.since and theme.since != current %} {{ theme.since }} - {% endif %}
  <span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love">
    <i class="fa fa-{{ theme.authoricon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ config.author }}</span>
</div>

{% if theme.copyright %}
<div class="powered-by">
  {{ __('footer.powered', '<a class="theme-link" href="https://hexo.io">Hexo</a>') }}
</div>

<div class="theme-info">
  {{ __('footer.theme') }} -
  <a class="theme-link" href="https://github.com/iissnan/hexo-theme-next">
    NexT.{{ theme.scheme }}
  </a>
</div>

<div class="busuanzi-count">

  <script async="" src="https://dn-lbstatics.qbox.me/busuanzi/2.3/busuanzi.pure.mini.js"></script>
    <!--本站访客数 -->
    <span class="site-uv"><i class="fa fa-user"></i><span class="busuanzi-value" id="busuanzi_value_site_uv"></span></span>
    <!--本站总访问量 -->
    <span class="site-uv"><i class="fa fa-cloud"></i><span class="busuanzi-value" id="busuanzi_value_site_pv"></span></span>
    <!--本文总阅读量 -->
    <span class="site-pv"><i class="fa fa-eye"></i><span class="busuanzi-value" id="busuanzi_value_page_pv"></span></span>   
  
  
</div>
{% endif %}
