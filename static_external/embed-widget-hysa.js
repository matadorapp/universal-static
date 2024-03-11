document.addEventListener('DOMContentLoaded', () => {
    const wrapper = document.querySelector('.public-widget-container-frame');
    if (wrapper) {
        const iframe = document.createElement('iframe');
        iframe.src = 'https://public.com/tools/high-yield-savings-calculator/embed';
        iframe.title = 'High Yield Savings Account Calculator';
        iframe.frameborder = 0;
        iframe.style.border = 'none';
        iframe.style.width = '100%';
        iframe.style.height = '900px';
        wrapper.appendChild(iframe);
        const style = `
        <style type="text/css">a.blue-text {display: block!important; color:#0038FF!important; text-decoration: none!important; font-size:14px!important; line-height: 1!important; padding: 4px!important; text-align: center!important}</style>
        `;
        wrapper.insertAdjacentHTML('afterend', style);
    }
});
