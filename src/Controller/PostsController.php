<?php

namespace App\Controller;

use App\Entity\Post;
use App\Repository\PostRepository;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

#[Route('/posts')]
class PostsController extends AbstractController
{
    #[Route('/', name: 'posts')]
    public function posts(PostRepository $postRepository): Response
    {
        return $this->render('posts/index.html.twig', [
            'posts' => $postRepository->findAll(),
        ]);
    }

    #[Route('/{slug:post}', name: 'post_by_slug')]
    public function postBySlug(Post $post): Response
    {
        return $this->render('posts/post.html.twig', [
            'post' => $post,
        ]);
    }
}
