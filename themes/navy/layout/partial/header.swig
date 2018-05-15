<div>
<header id="header" class="wrapper">
  <div id="header-inner" class="inner">
    <h1 id="logo-wrap">
      <a href="{{ url_for_lang('') }}" id="logo">DDES</a>
    </h1>
    <nav id="main-nav">
      {{ header_menu('main-nav') }}
    </nav>
    <div>
      <a href="https://github.com/{{ config.github }}" class="main-nav-link"><i class="fa fa-github-alt"></i></a>
    </div>
    <a id="mobile-nav-toggle">
      <span class="mobile-nav-toggle-bar"></span>
      <span class="mobile-nav-toggle-bar"></span>
      <span class="mobile-nav-toggle-bar"></span>
    </a>
  </div>
</header>
</div>