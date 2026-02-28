/**
 * 株式会社オービットワークス コーポレートサイト
 * メインJavaScriptファイル
 * - スクロールアニメーション（フェードイン）
 * - カウントアップアニメーション
 * - ヘッダースクロール追従
 * - モバイルメニュー
 * - フォーム送信処理（ダミー）
 */

document.addEventListener('DOMContentLoaded', () => {
  // ==================================
  // ヘッダースクロール追従
  // ==================================
  const header = document.getElementById('header');
  let lastScrollY = 0;

  const handleHeaderScroll = () => {
    const currentScrollY = window.scrollY;
    if (currentScrollY > 50) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
    lastScrollY = currentScrollY;
  };

  window.addEventListener('scroll', handleHeaderScroll, { passive: true });

  // ==================================
  // モバイルメニュー開閉
  // ==================================
  const mobileMenuBtn = document.getElementById('mobileMenuBtn');
  const navLinks = document.getElementById('navLinks');

  if (mobileMenuBtn && navLinks) {
    mobileMenuBtn.addEventListener('click', () => {
      navLinks.classList.toggle('is-open');
      // メニューアイコンのアニメーション
      const spans = mobileMenuBtn.querySelectorAll('span');
      if (navLinks.classList.contains('is-open')) {
        spans[0].style.transform = 'rotate(45deg) translate(5px, 5px)';
        spans[1].style.opacity = '0';
        spans[2].style.transform = 'rotate(-45deg) translate(5px, -5px)';
      } else {
        spans[0].style.transform = '';
        spans[1].style.opacity = '';
        spans[2].style.transform = '';
      }
    });

    // ナビリンクをクリックしたらメニューを閉じる
    navLinks.querySelectorAll('a').forEach(link => {
      link.addEventListener('click', () => {
        navLinks.classList.remove('is-open');
        const spans = mobileMenuBtn.querySelectorAll('span');
        spans[0].style.transform = '';
        spans[1].style.opacity = '';
        spans[2].style.transform = '';
      });
    });
  }

  // ==================================
  // フェードインアニメーション（Intersection Observer）
  // ==================================
  const fadeInElements = document.querySelectorAll('.fade-in');

  const fadeInObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('is-visible');
        fadeInObserver.unobserve(entry.target);
      }
    });
  }, {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
  });

  fadeInElements.forEach(el => fadeInObserver.observe(el));

  // ==================================
  // カウントアップアニメーション
  // ==================================
  const countElements = document.querySelectorAll('[data-count]');

  /**
   * 数値をアニメーションで表示する関数
   * @param {HTMLElement} el - 対象要素
   */
  const animateCount = (el) => {
    const target = parseFloat(el.dataset.count);
    const suffix = el.dataset.suffix || '';
    const isDecimal = el.dataset.decimal === 'true';
    const duration = 2000; // アニメーション時間（ミリ秒）
    const startTime = performance.now();

    const update = (currentTime) => {
      const elapsed = currentTime - startTime;
      const progress = Math.min(elapsed / duration, 1);

      // イージング（ease-out）
      const eased = 1 - Math.pow(1 - progress, 3);
      const current = eased * target;

      if (isDecimal) {
        el.textContent = current.toFixed(1) + suffix;
      } else {
        el.textContent = Math.floor(current) + suffix;
      }

      if (progress < 1) {
        requestAnimationFrame(update);
      } else {
        // 最終値を確定
        if (isDecimal) {
          el.textContent = target.toFixed(1) + suffix;
        } else {
          el.textContent = target + suffix;
        }
      }
    };

    requestAnimationFrame(update);
  };

  const countObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        animateCount(entry.target);
        countObserver.unobserve(entry.target);
      }
    });
  }, {
    threshold: 0.5
  });

  countElements.forEach(el => countObserver.observe(el));

  // ==================================
  // スムーズスクロール（ナビリンク）
  // ==================================
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', (e) => {
      e.preventDefault();
      const targetId = anchor.getAttribute('href');
      if (targetId === '#') return;

      const targetElement = document.querySelector(targetId);
      if (targetElement) {
        const headerHeight = header.offsetHeight;
        const targetPosition = targetElement.getBoundingClientRect().top + window.scrollY - headerHeight;

        window.scrollTo({
          top: targetPosition,
          behavior: 'smooth'
        });
      }
    });
  });

  // ==================================
  // お問い合わせフォーム（ダミー送信）
  // ==================================
  const contactForm = document.getElementById('contactForm');
  const formSuccess = document.getElementById('formSuccess');

  if (contactForm && formSuccess) {
    contactForm.addEventListener('submit', (e) => {
      e.preventDefault();

      // フォームを非表示にし、成功メッセージを表示
      contactForm.style.display = 'none';
      formSuccess.classList.add('is-visible');
    });
  }

  // ==================================
  // ページ読み込み完了時のヒーローアニメーション
  // ==================================
  const heroContent = document.querySelector('.hero-content');
  if (heroContent) {
    heroContent.style.opacity = '0';
    heroContent.style.transform = 'translateY(30px)';
    heroContent.style.transition = 'opacity 1s ease, transform 1s ease';

    // 少し遅延させて表示
    setTimeout(() => {
      heroContent.style.opacity = '1';
      heroContent.style.transform = 'translateY(0)';
    }, 200);
  }
});
