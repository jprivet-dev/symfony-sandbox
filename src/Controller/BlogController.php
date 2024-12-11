<?php

namespace App\Controller;

use App\Entity\Post;
use App\Repository\PostRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/blog')]
class BlogController extends AbstractController
{
    #[Route('/', name: 'app_blog')]
    public function index(PostRepository $postRepository): Response
    {
        return $this->render('blog/index.html.twig', [
            'posts' => $postRepository->findAll(),
        ]);
    }

    #[Route('/{slug:post}', name: 'app_blog_post_by_slug')]
    public function postBySlug(Post $post): Response
    {
        return $this->render('blog/post.html.twig', [
            'post' => $post,
        ]);
    }
}
