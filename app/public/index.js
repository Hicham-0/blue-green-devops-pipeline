(function () {
  'use strict';

  window.tailwind = window.tailwind || {};
  window.tailwind.config = {
    theme: {
      extend: {
        colors: {
          cream: '#EFE9E1',
          platinum: '#D9D9D9',
          warmgray: '#D1C7BD',
          espresso: '#322D29',
          burgundy: '#72383D',
          taupe: '#AC9C8D',
        },
        fontFamily: {
          display: ['Syne', 'Playfair Display', 'serif'],
          serif: ['Playfair Display', 'serif'],
          body: ['Plus Jakarta Sans', 'Inter', 'sans-serif'],
        },
        transitionTimingFunction: {
          luxury: 'cubic-bezier(0.25, 0.46, 0.45, 0.94)',
        },
      },
    },
  };

  function init() {
    /* ── Register GSAP plugin ── */
    gsap.registerPlugin(ScrollTrigger);

    /* ── Respect reduced motion ── */
    const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

    if (!prefersReducedMotion) {
      /* ── Fade-up animations for all major blocks ── */
      const fadeElements = document.querySelectorAll('.fade-up');

      fadeElements.forEach(function (el) {
        gsap.to(el, {
          opacity: 1,
          y: 0,
          duration: 0.8,
          ease: 'power2.out',
          scrollTrigger: {
            trigger: el,
            start: 'top 88%',
            toggleActions: 'play none none none',
          },
        });
      });

      /* ── Stagger pillar blocks in validation section ── */
      const pillars = document.querySelectorAll('.pillar-block');
      if (pillars.length) {
        gsap.set(pillars, { opacity: 0, y: 40 });
        gsap.to(pillars, {
          opacity: 1,
          y: 0,
          duration: 0.8,
          ease: 'power2.out',
          stagger: 0.12,
          scrollTrigger: {
            trigger: '#validation',
            start: 'top 80%',
            toggleActions: 'play none none none',
          },
        });
      }

      /* ── Hero entrance on load ── */
      const heroItems = document.querySelectorAll('#hero .fade-up');
      gsap.to(heroItems, {
        opacity: 1,
        y: 0,
        duration: 0.8,
        ease: 'power2.out',
        stagger: 0.15,
        delay: 0.2,
      });
    } else {
      /* Instantly reveal for reduced motion */
      document.querySelectorAll('.fade-up').forEach(function (el) {
        el.style.opacity = '1';
        el.style.transform = 'none';
      });
    }

    /* ── Header scroll state ── */
    const header = document.getElementById('header');
    let lastScroll = 0;

    function updateHeader() {
      const scrollY = window.scrollY;
      if (scrollY > 40) {
        header.classList.add('header-scrolled');
      } else {
        header.classList.remove('header-scrolled');
      }
      lastScroll = scrollY;
    }

    window.addEventListener('scroll', updateHeader, { passive: true });
    updateHeader();

    /* ── Smooth anchor scrolling with offset for fixed header ── */
    document.querySelectorAll('a[href^="#"]').forEach(function (anchor) {
      anchor.addEventListener('click', function (e) {
        const targetId = this.getAttribute('href');
        if (targetId === '#') return;

        const target = document.querySelector(targetId);
        if (!target) return;

        e.preventDefault();

        const headerHeight = header.offsetHeight;
        const targetPosition = target.getBoundingClientRect().top + window.scrollY - headerHeight - 16;
        window.scrollTo({
          top: targetPosition,
          behavior: prefersReducedMotion ? 'auto' : 'smooth',
        });
      });
    });

    /* ── Refresh ScrollTrigger on resize ── */
    let resizeTimer;
    window.addEventListener('resize', function () {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(function () {
        ScrollTrigger.refresh();
      }, 250);
    });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
